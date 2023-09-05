'use client'
import Image from 'next/image'
import { useState } from 'react';
import { FormProvider, useFieldArray, useForm, useFormContext } from "react-hook-form";


function MyRadio(
  {displayValue, formValue, register,  ...rest}: 
  {displayValue: string, formValue: string, register:any}
  ) {

  return <div>
    <input type="radio" value={formValue} {...register} {...rest} />
    {displayValue} 
  </div>
} // end MyRadio

function handleSubmission(value: any) {
  console.log("submitted")
  console.log(value)

} // end handleSubmission

function handleError(error: any) {
  console.log("error")
  console.log(error)
} // end handleError


function FieldArray() {
  const { control, register } = useFormContext();
  const { fields, append, prepend, remove, swap, move, insert } = useFieldArray({
    control, // control props comes from useForm (optional: if you are using FormContext)
    name: "file", // unique name for your Field Array
  });

  return (<div className='flex flex-col'>
    {fields.map((field: any, index: any) => {
      return (
        <div
          className='flex flex-row'
          key={field.id} // important to include key with field's id
        >
          <input
            type="file"
            {...register(`file.${index}.value`)} 
          />
          <button onClick={() => {remove(index)}} type="button">Remove</button>
        </div>

      ) // end return
    }) // end map
    }
    <button onClick={() => {append("")}} type="button">Add</button>
    </div>
  );
} // end FieldArray

export default function HomePage() {
  const [output, changeOutput] = useState("")

  const methods = useForm();
  const { register, handleSubmit } = methods;

  return (<div>
    <FormProvider {...methods}>
      <form onSubmit={handleSubmit(handleSubmission, handleError)} className='flex flex-col'>
        <label htmlFor='asp'>ASP Filename:</label>
        <input id="asp" type="file"  {...register('ASPFilename', {required: "need to have asp file name"})} />

        <label htmlFor='ontologies_list'>Ontologies:</label>
        <div id="ontologies_list">
          <FieldArray/>
        </div>

        <label htmlFor='solver_selection'>Solvers:</label>
        <MyRadio displayValue="Clingo" formValue="3" register={register("solver")} 
          {...{
            id: "solver_selection"
          }}
        />
        <MyRadio displayValue="DLV" formValue="4" register={register("solver")}
          {...{
            id: 'solver_selection'
          }}
        />
        <button type="submit">Query</button>
      </form>
    </FormProvider>


    <div>
      Output:
      {output}
    </div>
  </div>
  )
}
