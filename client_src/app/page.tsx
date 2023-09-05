'use client'
import Image from 'next/image'
import { useForm } from "react-hook-form";


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


function OntologyFileInput() {
  return <>
  </>
} // end OntologyFileInput

export default function HomePage() {
  const { register, handleSubmit } = useForm();

  return (<div>
    <form onSubmit={handleSubmit(handleSubmission, handleError)} className='flex flex-col'>
      <label htmlFor='asp'>ASP Filename:</label>
      <input id="asp" type="file"  {...register('ASPFilename', {required: "need to have asp file name"})} />

      <label htmlFor='ontologies_list'>Ontologies:</label>
      <div id="ontologies_list">
        <OntologyFileInput/>
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
  </div>
  )
}
